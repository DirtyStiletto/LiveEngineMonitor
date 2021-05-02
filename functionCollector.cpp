#include "functionCollector.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <net/if.h>
#include <sys/ioctl.h>
#include <sys/socket.h>

#include <linux/can.h>
#include <linux/can/raw.h>
#include <QString>

int unknownId = 0;
int unknownData = 0;
int canPotiVar = 0;
int smoothCanPotiVar = 0;
int roundedCanPotiVar = 0;
int canSWVarInt = 0;
float offsetZeigerpos = -127.5; //-127.5 danit Zeigerposition im GUI korrekt ist
bool canSWVarBool = false;
bool okRange = false; //Wertebereich grün
float smoothfaktor1 = 0.7;
float smoothfaktor2 = 1.0-smoothfaktor1;
int loop(){ for(int u=0; u<5; u++) { printf("Looptest\r\n");	} return 0; }
int canRxFrame(){
    int s; 
	int nbytes;
	struct sockaddr_can addr;
	struct ifreq ifr;
	struct can_frame frame;
     if ((s = socket(PF_CAN, SOCK_RAW, CAN_RAW)) < 0) {
		perror("Socket");
		return 1;
	}
    
    strcpy(ifr.ifr_name, "can0" );
	ioctl(s, SIOCGIFINDEX, &ifr);

	memset(&addr, 0, sizeof(addr));
	addr.can_family = AF_CAN;
	addr.can_ifindex = ifr.ifr_ifindex;

	if (bind(s, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
		perror("Bind");
		return 1;
	}
	nbytes = read(s, &frame, sizeof(struct can_frame));
 	if (nbytes < 0) {
		perror("Read");
		return 1;
	}
    if (frame.can_id == 0x001){
        canSWVarInt = frame.data[0];

		if(frame.data[0] == 1){ canSWVarBool = true; } else{canSWVarBool = false;}
    }
	else if (frame.can_id == 0x002){
		canPotiVar = frame.data[0] | (frame.data[1]<<8);
		smoothCanPotiVar = smoothfaktor1 * smoothCanPotiVar + smoothfaktor2 * canPotiVar;
		roundedCanPotiVar = frame.data[7];
	}
	else { 
		unknownId = frame.can_id;
		unknownData = frame.data[0] + frame.data[1] + frame.data[2] + frame.data[3] + frame.data[4] + frame.data[5] + frame.data[6] + frame.data[7];
	}

	if (close(s) < 0) {
		perror("Close");
		return 1;
	}
	return 0;
}


functionCollector::functionCollector(QObject *parent) : QObject(parent)
{

}

void functionCollector::changeValue()
{
	canRxFrame();
 	valChangedPotiTrue(smoothCanPotiVar); 
	valChangedPotiGraph(roundedCanPotiVar);
	valChangedSW(canSWVarBool);
	valChangedUI(unknownId);
	valChangedUD(unknownData);
	
   /* valueChangedPoti(QString::number(roundedCanPotiVar)); 
	valueChangedSW(canSWVarBool);
	valueChangedText(QString::number(smoothCanPotiVar));
	valueChangedUI(QString::number(unknownId));
	valueChangedUD(QString::number(unknownData));
	valueChangedRange(okRange);*/
}
void functionCollector::changeLanguage(bool gui_changerequest) {
	if(gui_changerequest==false){
    	languageChanged("DE");
	}
	if(gui_changerequest==true){
		languageChanged("EN");
	}
}