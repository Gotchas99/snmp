Class {
	#name : 'ASN1PDUGetNextType',
	#superclass : 'ASN1PDUType',
	#category : 'CAs-SNMP-ASN1',
	#package : 'CAs-SNMP',
	#tag : 'ASN1'
}

{ #category : 'as yet unclassified' }
ASN1PDUGetNextType class >> pduType [

	^ 'GetNext-PDU'
]

{ #category : 'accessing' }
ASN1PDUGetNextType >> tagNumber [

	^ 1
]
