Class {
	#name : 'ASN1PDUGetType',
	#superclass : 'ASN1PDUType',
	#category : 'CAs-SNMP-ASN1',
	#package : 'CAs-SNMP',
	#tag : 'ASN1'
}

{ #category : 'as yet unclassified' }
ASN1PDUGetType class >> pduType [

	^ 'Get-PDU'
]

{ #category : 'accessing' }
ASN1PDUGetType >> tagNumber [

	^  0
]
