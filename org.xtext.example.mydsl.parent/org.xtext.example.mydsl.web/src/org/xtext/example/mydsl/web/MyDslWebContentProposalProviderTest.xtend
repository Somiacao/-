package org.xtext.example.mydsl.web

import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistEntry


class MyDslWebContentProposalProviderTest extends IdeContentProposalProvider {
		
	override protected void _createProposals(Keyword keyword, ContentAssistContext context, IIdeContentProposalAcceptor acceptor) {
		System.out.println("bindIdeContentProposalProviderTestIn")
		var boolean _filterKeyword = this.filterKeyword(keyword, context)
		if (_filterKeyword) {
			val ContentAssistEntry entry = this.proposalCreator.createProposal(keyword.getValue(), context)
			if ((entry !== null)) {
				if (context.prefix == "" && "a" == keyword.value) { // use constants in MydslGrammarAccess
					entry.prefix = "$"
					entry.proposal = "$" + entry.proposal
					entry.label = "a"
				}
				System.err.println(context.prefix)
				entry.setKind(ContentAssistEntry.KIND_KEYWORD)
				acceptor.accept(entry, this.proposalPriorities.getKeywordPriority(keyword.getValue(), entry))
			}
		}
		
	}
}