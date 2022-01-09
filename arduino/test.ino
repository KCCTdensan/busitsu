// Arduino入門編㉑ 温湿度センサーの情報をシリアルモニタに表示
// https://burariweb.info

#include <DHT.h>              // ライブラリのインクルード

#define DHT_PIN 7             // DHT11のDATAピンをデジタルピン7に定義
#define DHT_MODEL DHT11       // 接続するセンサの型番を定義する(DHT11やDHT22など)

DHT dht(DHT_PIN, DHT_MODEL);  // センサーの初期化

boolean toneSetting = 0;
int toneIndex=0,tempData=0, toneData[15] {523, 587, 659, 698, 784, 880, 988, 1047, 1175, 1319, 1397, 1568, 1760, 1976, 2093};
float tempDelta = 0.0,Humidity=0.0,Temperature=0.0;

void setup() {
  pinMode(A0, INPUT);
  pinMode(5, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(3, OUTPUT);
  Serial.begin(9600);         // シリアル通信の開始

  dht.begin();                // センサーの動作開始

}


void loop() {
  if (digitalRead(A0) == 1) {
    toneSetting = 1;
  } else {
    toneSetting = 0;
  }
  noTone(5);
  delay(2000);                // センサーの読み取りを2秒間隔に
  tempCompare();
  toneCall(toneSetting);
  tempDelta = dht.readTemperature() - Temperature;
  Humidity = dht.readHumidity();          // 湿度の読み取り
  Temperature = dht.readTemperature();    // 温度の読み取り(摂氏)

  if (isnan(Humidity) || isnan(Temperature)) {  // 読み取りのチェック
    Serial.println(-255);
    pushError();
  }

  // シリアルモニタに温度&湿度を表示
  Serial.print(Temperature);
  Serial.print(',');

  Serial.print(Humidity);
  Serial.println();
}

void toneCall(boolean set) {
  switch (set) {
    case 0:
      tone(5, toneData[toneIndex]);
      toneIndex++;
      if (toneIndex >= 15) {
        toneIndex = 0;
      }
      break;

    case 1:
      toneIndex=0;
      toneTemp();
  }
}


//forJMA,tempName 猛暑日:max>=35 真夏日:max>=30 夏日:max>=25 冬日:min<0 真冬日 max<0
void toneTemp(){
  tempData=(int)Temperature;
  toneIndex=0;
  for(int i=3;i<17;i++){
    if(tempData<=i*2){continue;}
    toneIndex++;
  }
  tone(5,toneData[toneIndex]);
}

void tempCompare(){
  if(tempDelta>0.0){
    redCall(1);
    greenCall(0);
  }else if(tempDelta<0.0){
    redCall(0);
    greenCall(1);
  }else{
    redCall(0);
    greenCall(0);
  }
}

void redCall(boolean rhl){
  digitalWrite(4,rhl);
}

void greenCall(boolean ghl){
  digitalWrite(3,ghl);
}

void pushError(){
  tone(5,1000);
  while(1){
    redCall(1);
    greenCall(1);
    delay(500);
    redCall(0);
    greenCall(0);
    delay(500);
  }
}