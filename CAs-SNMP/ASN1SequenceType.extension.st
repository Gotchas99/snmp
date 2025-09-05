Extension { #name : 'ASN1SequenceType' }

{ #category : '*CAs-SNMP' }
ASN1SequenceType >> asn1ValueClass [

	^ ASN1SequenceValue 
]

{ #category : '*CAs-SNMP' }
ASN1SequenceType class >> decode: anEncodedConstructedValue [
| coll |
coll:=anEncodedConstructedValue elements collect:[:each|ASN1 decodeValue: each].
^coll
]

{ #category : '*CAs-SNMP' }
ASN1SequenceType >> newValue: anObject [

	^ self newValue contents: anObject
]
