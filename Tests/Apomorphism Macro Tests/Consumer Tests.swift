import Corecursive_Macro
import Functor_Base_Macro
import Apomorphism_Macro
import Either
import Testing

@Corecursive
@FunctorBase
@Apomorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `apomorphism can graft an existing recursive branch`() {
    let existing = Natural.successor(.zero)
    let value = Natural.apomorphism(1) { _ -> Natural.Base<Either<Natural, Int>> in
        .successor(.left(existing))
    }
    guard case .successor(.successor(.zero)) = value else {
        Issue.record("Expected grafted branch")
        return
    }
}
