Class {
	#name : 'ASN1PDUType',
	#superclass : 'ASN1SequenceType',
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'adding' }
ASN1PDUType class >> addApplicationTagNumberMapTo: aDict [

	^ aDict
		  at: 'Get-PDU' put: 0;
		  at: 'GetNext-PDU' put: 1;
		  at: 'Response-PDU' put: 2;
		  yourself
]

{ #category : 'as yet unclassified' }
ASN1PDUType class >> classForPDUtype: aPduType [

	| t |
	t := self allSubclasses detect: [ :each |
		     each pduType = aPduType ].
	^ t
]

{ #category : 'instance creation' }
ASN1PDUType >> asn1ValueClass [ ^ASN1PDUValue 
]

{ #category : 'accessing' }
ASN1PDUType >> tag [ 
^ASN1Tag clazz:nil number: 0.
]
