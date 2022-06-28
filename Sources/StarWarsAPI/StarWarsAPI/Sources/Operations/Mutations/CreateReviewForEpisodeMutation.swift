// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable

public class CreateReviewForEpisodeMutation: GraphQLMutation {
  public static let operationName: String = "CreateReviewForEpisode"
  public static let document: DocumentType = .automaticallyPersisted(
    operationIdentifier: "9bbf5b4074d0635fb19d17c621b7b04ebfb1920d468a94266819e149841e7d5d",
    definition: .init(
      """
      mutation CreateReviewForEpisode($episode: Episode!, $review: ReviewInput!) {
        createReview(episode: $episode, review: $review) {
          __typename
          stars
          commentary
        }
      }
      """
    ))

  public var episode: GraphQLEnum<Episode>
  public var review: ReviewInput

  public init(
    episode: GraphQLEnum<Episode>,
    review: ReviewInput
  ) {
    self.episode = episode
    self.review = review
  }

  public var variables: Variables? {
    ["episode": episode,
     "review": review]
  }

  public struct Data: StarWarsAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { .Object(StarWarsAPI.Mutation.self) }
    public static var selections: [Selection] { [
      .field("createReview", CreateReview?.self, arguments: [
        "episode": .variable("episode"),
        "review": .variable("review")
      ]),
    ] }

    public var createReview: CreateReview? { __data["createReview"] }

    /// CreateReview
    public struct CreateReview: StarWarsAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { .Object(StarWarsAPI.Review.self) }
      public static var selections: [Selection] { [
        .field("stars", Int.self),
        .field("commentary", String?.self),
      ] }

      public var stars: Int { __data["stars"] }
      public var commentary: String? { __data["commentary"] }
    }
  }
}