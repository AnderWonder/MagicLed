#include <tiny13a.h>
#include <delay.h>
#include <stdlib.h>
//PINS
#define RED_PIN 0
#define GREEN_PIN 2
#define BLUE_PIN 1
#define SENSOR_OUT_PIN 4
#define SENSOR_IN_PIN 3

unsigned char pwm_counter=0;//счЄтчик Ў»ћ цикла
unsigned char red_bs=0;//€ркость светодиода1 (0-255)
unsigned char green_bs=0;//€ркость светодиода2 (0-255) 
unsigned char blue_bs=0;//€ркость светодиода3 (0-255)

unsigned int sensorNotTouched=0;

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    PORTB.RED_PIN=(pwm_counter<red_bs);
    PORTB.GREEN_PIN=(pwm_counter<green_bs>>1);//коррекци€ €ркости зеленого
    PORTB.BLUE_PIN=(pwm_counter<blue_bs);
    pwm_counter++;    
}
void common_init()
{
    #pragma optsize-
    //Crystal Oscillator division factor: 1
    CLKPR=0x80;
    CLKPR=0x00;
    //Analog Comparator: Off
    ACSR=0x80;
    //and ADC off in power reduction
    PRR=1;  
    //установка режима таймера
    // Mode: Normal
    //TCCR0A=0;
    // division factor: 1
    TCCR0B=1;
    //timer interrupt on overflow
    TIMSK0=0b10;
    // Input/Output Ports initialization
    DDRB.SENSOR_OUT_PIN=1;
    DDRB.SENSOR_IN_PIN=0;
    DDRB.RED_PIN=1;
    DDRB.BLUE_PIN=1;
    DDRB.GREEN_PIN=1; 
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif
}
void change_color(unsigned char to_red,unsigned char to_green,unsigned char to_blue,unsigned char pause)
{
    while(red_bs!=to_red||green_bs!=to_green||blue_bs!=to_blue){
        if(to_red!=red_bs)
            if(to_red>red_bs)red_bs++;
            else red_bs--;
        if(to_green!=green_bs)
            if(to_green>green_bs)green_bs++;
            else green_bs--;
        if(to_blue!=blue_bs)
            if(to_blue>blue_bs)blue_bs++;
            else blue_bs--;
        if(pause)delay_ms(pause);
    } 
}
unsigned int countSensor()
{
    unsigned int sensorValue;
    unsigned char TCNT0Save;
    #asm("cli")    
    TCNT0Save=TCNT0;
    TCNT0=0;
    PORTB.SENSOR_OUT_PIN=1;
    while(!PINB.SENSOR_IN_PIN);
    sensorValue=TCNT0;
    TCNT0=TCNT0Save;    
    #asm("sei")
    PORTB.SENSOR_OUT_PIN=0;       
    return sensorValue;
}
void sensorCalibration()
{
    unsigned char i;
    //расчитываем среднее значение непритронутого сенсора
    for(i=1;i<=50;i++){
        if (sensorNotTouched){
            sensorNotTouched+=countSensor();
            sensorNotTouched/=2;
        }
        else sensorNotTouched=countSensor();
        if(red_bs)red_bs=green_bs=blue_bs=0;
        else red_bs=green_bs=blue_bs=5; 
        delay_ms(50);
        }
    //прибавл€ем порог
    sensorNotTouched+=sensorNotTouched/16;
}
void main(void)
{
    unsigned char n,m,k,i;
    //обща€ инициализаци€
    common_init();              
    //инициализаци€ генератора случ. чисел     
    /*n=3;
    for(k=0;k<=3;k++){
        for(m=0;m<255;m++){
            switch(k){
                case RED_PIN:
                    change_color(m,0,0,n);
                    break;
                case GREEN_PIN:
                    change_color(0,m,0,n);
                    break;
                case BLUE_PIN:
                    change_color(0,0,m,n);
                    break;
                default:
                    change_color(m,m,m,n);
            }
        }
       change_color(0,0,0,n); 
    }*/
    //мигаем красным, синим и зелЄным перед калибровкой
    for(i=1;i<8;i*=2){
        PORTB=i;
        delay_ms(500);
    }          
        
    sensorCalibration();    
    /*if (sensorNotTouched>10)n=1;
    if (sensorNotTouched>50)n=2;
    if (sensorNotTouched>80)n=3;
    if (sensorNotTouched>1000)n=3;
    for(k=0;k<n;k++){
        red_bs=255;
        delay_ms(500);
        red_bs=0;
        delay_ms(1000);
    }*/        
    srand(sensorNotTouched);
    //#asm("sei")//разрешение прерываний
    while (1){
        if(countSensor()>sensorNotTouched){
            //red_bs=green_bs=blue_bs=50;
            
            change_color(rand(),rand(),rand(),5);
            //change_color(0,0,0,50);
                        
        }
        else{
            change_color(0,0,0,50);            
        }   
        delay_ms(100); 
    }
}
