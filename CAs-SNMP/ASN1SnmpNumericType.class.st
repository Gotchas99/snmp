Class {
	#name : 'ASN1SnmpNumericType',
	#superclass : 'ASN1SnmpPrimitiveType',
	#category : 'CAs-SNMP-ASN1',
	#package : 'CAs-SNMP',
	#tag : 'ASN1'
}

{ #category : 'codec' }
ASN1SnmpNumericType class >> decode: aByteArray [

	^ASN1IntegerType decode: aByteArray
]

{ #category : 'codec' }
ASN1SnmpNumericType class >> encode: aByteArray [

^	ASN1IntegerType encode: aByteArray
]
