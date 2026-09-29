import Corecursive_Macro
import Functor_Base_Macro
import Apomorphism_Macro
import Either
import Testing

@Corecursive
@FunctorBase
@Apomorphism
private indirect enum Count {
    case zero
    case successor(Count)
}

private func depth(_ value: Count) -> Int {
    switch value {
    case .zero: 0
    case let .successor(child): depth(child) + 1
    }
}

@Suite
struct `Apomorphism boundaries` {
    @Test
    func `a seed that stops at once unfolds to the base case`() {
        let value = Count.apomorphism(0) { _ -> Count.Base<Either<Count, Int>> in .zero }
        #expect(depth(value) == 0)
    }

    @Test
    func `seeds keep unfolding until the coalgebra stops`() {
        let value = Count.apomorphism(5) { seed -> Count.Base<Either<Count, Int>> in
            seed == 0 ? .zero : .successor(.right(seed - 1))
        }
        #expect(depth(value) == 5)
    }
}
