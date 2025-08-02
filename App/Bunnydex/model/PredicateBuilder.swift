//
//  PredicateBuilder.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/25/25.
//

import SwiftUI
import SwiftData

struct CardPredicate: Equatable {
    var searchFilter: String = ""
    var decks: Set<Deck> = []
    var types: Set<CardType> = []
    var requirements: Set<BunnyRequirement> = []
    var pawns: Set<Pawn> = []
    var dice: Set<Die> = []
    var symbols: Set<Symbol> = []

    var predicate: Predicate<CardModel> {
        return predicateBuilder(searchFilter: searchFilter, decks: decks, types: types, requirements: requirements, pawns: pawns, dice: dice, symbols: symbols)
    }
}

func predicateBuilder(searchFilter: String = "", decks: Set<Deck> = [], types: Set<CardType> = [], requirements: Set<BunnyRequirement> = [], pawns: Set<Pawn> = [], dice: Set<Die> = [], symbols: Set<Symbol> = []) -> Predicate<CardModel> {
    func buildConjunction(lhs: some StandardPredicateExpression<Bool>, rhs: some StandardPredicateExpression<Bool>) -> any StandardPredicateExpression<Bool> {
        PredicateExpressions.Conjunction(lhs: lhs, rhs: rhs)
    }

    let rawDecks = decks.map(\.rawValue)
    let rawTypes = types.map(\.rawValue)
    let rawRequirements = requirements.map(\.rawValue)
    let rawPawns = pawns.map(\.rawValue)
    let rawDice = dice.map(\.rawValue)
    let rawSymbols = symbols.map(\.rawValue)

    return Predicate<CardModel> { card in
        var conditions: [any StandardPredicateExpression<Bool>] = []

        if !searchFilter.isEmpty {
            conditions.append(
                PredicateExpressions.build_Disjunction(
                    lhs: PredicateExpressions.build_localizedStandardContains(
                        PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg(card),
                            keyPath: \.title
                        ),
                        PredicateExpressions.build_Arg(searchFilter)
                    ),
                    rhs: PredicateExpressions.build_Equal(
                        lhs: PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg(card),
                            keyPath: \.cardId
                        ),
                        rhs: PredicateExpressions.build_Arg(searchFilter)
                    )
                )
            )
        }

        if !decks.isEmpty {
            conditions.append(
                PredicateExpressions.build_contains(
                    PredicateExpressions.build_Arg(rawDecks),
                    PredicateExpressions.build_KeyPath(
                        root: PredicateExpressions.build_Arg(card),
                        keyPath: \.rawDeck
                    )
                )
            )
        }

        if !types.isEmpty {
            conditions.append(
                PredicateExpressions.build_contains(
                    PredicateExpressions.build_Arg(rawTypes),
                    PredicateExpressions.build_KeyPath(
                        root: PredicateExpressions.build_Arg(card),
                        keyPath: \.rawType
                    )
                )
            )
        }

        if !requirements.isEmpty {
            conditions.append(
                PredicateExpressions.build_contains(
                    PredicateExpressions.build_Arg(rawRequirements),
                    PredicateExpressions.build_KeyPath(
                        root: PredicateExpressions.build_Arg(card),
                        keyPath: \.rawRequirement
                    )
                )
            )
        }

        if !pawns.isEmpty {
            conditions.append(
                PredicateExpressions.build_contains(
                    PredicateExpressions.build_Arg(rawPawns),
                    PredicateExpressions.build_KeyPath(
                        root: PredicateExpressions.build_Arg(card),
                        keyPath: \.rawPawn
                    )
                )
            )
        }

        for dieID in rawDice {
            conditions.append(
                PredicateExpressions.build_contains(
                    PredicateExpressions.build_KeyPath(
                        root: PredicateExpressions.build_Arg(card),
                        keyPath: \.dice
                    ),
                    where: {
                        PredicateExpressions.build_Equal(
                            lhs: PredicateExpressions.build_KeyPath(
                                root: PredicateExpressions.build_Arg($0),
                                keyPath: \.id
                            ),
                            rhs: PredicateExpressions.build_Arg(dieID)
                        )
                    }
                )
            )
        }

        for symbolID in rawSymbols {
            conditions.append(
                PredicateExpressions.build_contains(
                    PredicateExpressions.build_KeyPath(
                        root: PredicateExpressions.build_Arg(card),
                        keyPath: \.symbols
                    ),
                    where: {
                        PredicateExpressions.build_Equal(
                            lhs: PredicateExpressions.build_KeyPath(
                                root: PredicateExpressions.build_Arg($0),
                                keyPath: \.id
                            ),
                            rhs: PredicateExpressions.build_Arg(symbolID)
                        )
                    }
                )
            )
        }

        guard let first = conditions.first else {
            return PredicateExpressions.Value(true)
        }

        let closure: (any StandardPredicateExpression<Bool>, any StandardPredicateExpression<Bool>) -> any StandardPredicateExpression<Bool> = {
            buildConjunction(lhs: $0, rhs: $1)
        }

        return conditions.dropFirst().reduce(first, closure)
    }
}

