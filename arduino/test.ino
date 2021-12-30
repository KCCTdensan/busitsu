// Arduino入門編㉑ 温湿度センサーの情報をシリアルモニタに表示
// https://burariweb.info

#include <DHT.h>              // ライブラリのインクルード

#define DHT_PIN 7             // DHT11のDATAピンをデジタルピン7に定義
#define DHT_MODEL DHT11       // 接続するセンサの型番を定義する(DHT11やDHT22など)

DHT dht(DHT_PIN, DHT_MODEL);  // センサーの初期化



void setup() {
  pinMode(A0,INPUT);
  pinMode(5,OUTPUT);
  pinMode(4,OUTPUT);
  Serial.begin(9600);         // シリアル通信の開始
  
  dht.begin();                // センサーの動作開始
  
}


void loop(){
  digitalWrite(4,0);
  noTone(5);
  delay(2000);                // センサーの読み取りを2秒間隔に
  tone(5,1000);
  digitalWrite(4,0);
  float Humidity = dht.readHumidity();          // 湿度の読み取り
  float Temperature = dht.readTemperature();    // 温度の読み取り(摂氏)

  if (isnan(Humidity) || isnan(Temperature)) {  // 読み取りのチェック
    Serial.println(-255);
    while(1){
      bool nida=0;
      tone(5,1000);
      digitalWrite(4,nida);
      nida=not(nida);
      delay(100);
    }
  }

// シリアルモニタに温度&湿度を表示  
  Serial.print(Temperature);
  Serial.print(',');

  Serial.print(Humidity);  
  Serial.println();
}