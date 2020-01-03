package org.xtext.example.mydsl

import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy
import org.eclipse.xtext.scoping.impl.ImportUriResolver
import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.util.IAcceptor
import org.eclipse.xtext.resource.IEObjectDescription
import org.xtext.example.mydsl.myDsl.Model
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.xtext.example.mydsl.myDsl.ImportDefinition

class MyDslResourceDescriptionStrategy extends DefaultResourceDescriptionStrategy {
	public static final String INCLUDES = 'includes'
	
	@Inject
	ImportUriResolver uriResolver;
	
	override createEObjectDescriptions(EObject eObject,IAcceptor<IEObjectDescription> acceptor){
		if(eObject instanceof Model){
			this.createEObjectDescriptionForModel(eObject,acceptor)
			return true
		}
		else{
			super.createEObjectDescriptions(eObject,acceptor)
		}
	}
	
	def createEObjectDescriptionForModel(Model model, IAcceptor<IEObjectDescription> acceptor) {
//		System.out.println(model.model.length)
		val includes = new ArrayList<ImportDefinition>
		for(definition : model.model){
			if(definition.includes.length > 0){
				includes.add(definition.includes.get(0))
			}
		}
		
//		System.out.println(includes.length)
		
		for(definition : model.model){
			val uris = new ArrayList()

			if(definition.includes.length > 0){
				includes.forEach[uris.add(uriResolver.apply(it))]
				
				
				val userData = new HashMap<String,String>
		
				userData.put(INCLUDES,uris.join(","))
		
				acceptor.accept(EObjectDescription.create(QualifiedName.create(definition.eResource.URI.toString),definition,userData))
				
				
				return
			}
			
			
		}
		
		
	}
	
}