import OrderedCollections

struct OperationDefinitionTemplate {

  let operation: IR.Operation
  let schema: IR.Schema
  let config: ApolloCodegenConfiguration

  func render() -> String {
    TemplateString(
    """
    \(HeaderCommentTemplate.render())

    \(ImportStatementTemplate.Operation.render(config.output))

    \(OperationDeclaration(operation.definition))
      \(DocumentType.render(operation.definition, fragments: operation.referencedFragments, apq: config.apqs))

      public init() {}

      \(SelectionSetTemplate(schema: schema).render(for: operation))
    }
    """).description
  }

  func OperationDeclaration(_ operation: CompilationResult.OperationDefinition) -> TemplateString {
    return """
    public class \(operation.nameWithSuffix): \(operation.operationType.renderedProtocolName) {
      public let operationName: String = "\(operation.name)"
    """
  }

  enum DocumentType {
    static func render(
      _ operation: CompilationResult.OperationDefinition,
      fragments: OrderedSet<CompilationResult.FragmentDefinition>,
      apq: ApolloCodegenConfiguration.APQConfig
    ) -> TemplateString {
      let includeFragments = !fragments.isEmpty
      let includeDefinition = apq != .persistedOperationsOnly

      return TemplateString("""
      public let document: DocumentType = .\(apq.rendered)(
      \(if: apq != .disabled, """
        operationIdentifier: \"\(operation.operationIdentifier)\"\(if: includeDefinition, ",")
      """)
      \(if: includeDefinition, """
        definition: .init(
          ""\"
          \(operation.source)
          ""\"\(if: includeFragments, ",")
          \(if: includeFragments,
                            "fragments: [\(fragments.map { "\($0.name).self" }, separator: ", ")]")
        ))
      """,
      else: """
      )
      """)
      """
      )
    }
  }
}

fileprivate extension ApolloCodegenConfiguration.APQConfig {
  var rendered: String {
    switch self {
    case .disabled: return "notPersisted"
    case .automaticallyPersist: return "automaticallyPersisted"
    case .persistedOperationsOnly: return "persistedOperationsOnly"
    }
  }
}

fileprivate extension CompilationResult.OperationType {
  var renderedProtocolName: String {
    switch self {
    case .query: return "GraphQLQuery"
    case .mutation: return "GraphQLMutation"
    case .subscription: return "GraphQLSubscription"
    }
  }
}