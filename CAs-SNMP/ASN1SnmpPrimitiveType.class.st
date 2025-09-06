Class {
	#name : 'ASN1SnmpPrimitiveType',
	#superclass : 'ASN1PrimitiveType',
	#classVars : [
		'snmpTagNumbers'
	],
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'accessing' }
ASN1SnmpPrimitiveType class >> createSnmpTagNumberMap [
	"at: 'Unsigned32' put: 2; -- an unsigned 32-bit quantity, indistinguishable from Gauge32"

	^ Dictionary new 
		  at: 'IpAddress' put: 0;
		  at: 'Counter32' put: 1;
		  at: 'Gauge32' put: 2;
		  at: 'TimeTicks' put: 3;
		  at: 'Opaque' put: 4;
		  at: 'Counter64' put: 6;
		  yourself
]

{ #category : 'accessing' }
ASN1SnmpPrimitiveType class >> resetSnmpTagNumbers [

	snmpTagNumbers := nil
]

{ #category : 'accessing' }
ASN1SnmpPrimitiveType class >> snmpTagNumbers [

	^ snmpTagNumbers ifNil: [snmpTagNumbers := self createSnmpTagNumberMap ]
]

{ #category : 'accessing' }
ASN1SnmpPrimitiveType class >> snmpType [ 	^ 'NOT APPLICABLE to Abstract type'
]

{ #category : 'accessing' }
ASN1SnmpPrimitiveType class >> tagNumber [

	^ self snmpTagNumbers at: self snmpType ifAbsent: [ -1 ]
]
