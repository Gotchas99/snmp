Extension { #name : 'ASN1Tag' }

{ #category : '*CAs-SNMP' }
ASN1Tag >> printOn: aStream [

	aStream
		nextPutAll: (self clazz ifNil: [ 'CONTEXT' ]);
		nextPut: $:;
		nextPutAll: self number printString.
	self clazz = 'UNIVERSAL' ifTrue: [
			aStream
				nextPut: $:;
				nextPutAll: (ASN1EncodedType universalTypeForNumber:number) ]
]
