package org.xtext.example.mydsl

import org.eclipse.xtext.scoping.impl.ImportUriGlobalScopeProvider
import com.google.common.base.Splitter
import com.google.inject.Inject
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.xtext.util.IResourceScopeCache
import java.util.LinkedHashSet
import org.eclipse.emf.common.util.URI
import com.google.inject.Provider
import org.eclipse.xtext.EcoreUtil2
import org.xtext.example.mydsl.myDsl.MyDslPackage
import org.eclipse.emf.ecore.resource.Resource
import java.util.ArrayList
import java.util.HashMap
import org.xtext.example.mydsl.myDsl.FunctionDefinition
import org.xtext.example.mydsl.myDsl.TopicDefinition

class MyDslGlobalScopeProvider extends ImportUriGlobalScopeProvider {
	
	private static final Splitter SPLITTER = Splitter.on(',');
	
	public static val Functions = new HashMap<String,String>();
	
	public static val Topics = new HashMap<String,String>();
	

	@Inject
	IResourceDescription.Manager descriptionManager;

	@Inject
	IResourceScopeCache cache;
	

	override protected getImportedUris(Resource resource) {
		return cache.get(MyDslGlobalScopeProvider.getSimpleName(), resource, new Provider<LinkedHashSet<URI>>() {
			override get() {
				val uniqueImportURIs = collectImportUris(resource, new LinkedHashSet<URI>(5))

				val uriIter = uniqueImportURIs.iterator()
				System.out.println(uriIter.toString)
				while(uriIter.hasNext()) {
					if (!EcoreUtil2.isValidUri(resource, uriIter.next()))
						uriIter.remove()
				}
				return uniqueImportURIs
			}

			def LinkedHashSet<URI> collectImportUris(Resource resource, LinkedHashSet<URI> uniqueImportURIs) {
				val resourceDescription = descriptionManager.getResourceDescription(resource)
//				System.out.println(resourceDescription.toString)
				val models = resourceDescription.getExportedObjectsByType(MyDslPackage.Literals.DEFINITION)
				
				
				val address = new ArrayList<String>()
				
				address.add("https://cdn.sine-x.com/mydsl/function.mydsl")
				address.add("https://cdn.sine-x.com/mydsl/topic.mydsl")


				models.forEach[
					val userData = getUserData(MyDslResourceDescriptionStrategy.INCLUDES)
//					System.out.println(userData)
					if(userData !== null) {
						SPLITTER.split(userData).forEach[uri |
							var includedUri = URI.createURI(uri)
							if(address.contains(includedUri.toString)){
								if(uniqueImportURIs.add(includedUri)) {
									val resourceTemp = resource.getResourceSet().getResource(includedUri, true)
									collectImportUris(resourceTemp, uniqueImportURIs)
//									将uri中的资源读取出来
									achieveFunction(resourceTemp)
									achieveTopic(resourceTemp)
								}
							}
						]
					}
				]
				
				return uniqueImportURIs
			}
		});
	}
	
	
	// 获取function的所有定义
	def achieveFunction(Resource resource){
//		var functions = new HashMap<String,String>()
		for(function : resource.allContents.filter(FunctionDefinition).toIterable){
			System.out.println(function.name)
			var service = ''
			for(arg: function.service.args){
				service += '/'+arg
			}
			var post = ''
			if(function.service.number !== null){
				post = ':' + function.service.number
			}
			Functions.put(function.name,function.service.servicename+post+service);
//			System.out.println(function.service.servicename+post+service)
		}
//		return functions
	}


// 获取topic的所有定义
	def achieveTopic(Resource resource){
//		var topics = new HashMap<String,String>()
		for(topic : resource.allContents.filter(TopicDefinition).toIterable){
//			System.out.println(topic.name)
			var subtopic = ''
			for(String topicString:topic.topic.topic){
				subtopic += topicString
			}
			Topics.put(topic.name,subtopic)
		}
//		return topics
	}
	
}