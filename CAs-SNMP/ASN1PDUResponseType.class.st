Class {
	#name : 'ASN1PDUResponseType',
	#superclass : 'ASN1PDUType',
	#category : 'CAs-SNMP-ASN1',
	#package : 'CAs-SNMP',
	#tag : 'ASN1'
}

{ #category : 'as yet unclassified' }
ASN1PDUResponseType class >> pduType [

	^ 'Response-PDU'
]

{ #category : 'accessing' }
ASN1PDUResponseType >> tagNumber [

	^ 2
]
