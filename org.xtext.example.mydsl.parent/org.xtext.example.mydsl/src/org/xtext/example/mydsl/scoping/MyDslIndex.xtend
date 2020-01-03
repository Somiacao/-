package org.xtext.example.mydsl.scoping

import com.google.inject.Inject
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.eclipse.emf.ecore.EObject
import org.xtext.example.mydsl.myDsl.MyDslPackage

class MyDslIndex {
	@Inject ResourceDescriptionsProvider rdp
	
	def getResourceDescription(EObject o){
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.URI)
	}
	
	def getExportedEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjects
	}
	def getExportedClassesEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjectsByType(MyDslPackage.eINSTANCE.definition)
	}
	
}