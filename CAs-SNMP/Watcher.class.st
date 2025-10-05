Class {
	#name : 'Watcher',
	#superclass : 'Object',
	#instVars : [
		'prev'
	],
	#category : 'CAs-SNMP-Application',
	#package : 'CAs-SNMP',
	#tag : 'Application'
}

{ #category : 'initialization' }
Watcher >> initialize [ 
prev:=0
]

{ #category : 'accessing' }
Watcher >> next [
 | future sess diff oldval |
future :=   [sess getSingle: '1.3.6.1.2.1.2.2.1.10.49'. "ifInOctets"] future.
	future onSuccessDo: [:newval | diff :=newval - oldval.
   Transcript crShow: 'Bytes in: ', diff asString.
	oldval:= newval]
]
