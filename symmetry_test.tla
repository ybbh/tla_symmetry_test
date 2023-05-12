------------------------ MODULE symmetry_test ------------------------

EXTENDS Sequences, Naturals, FiniteSets

CONSTANTS
    MID,        \* set of MID *
    NID         \* set of NID *
    
VARIABLES
    state,           
    event
    
variables == <<
    state,
    event
>>


\* constant string definition

_S0 == "s0"
_S1 == "s1"


T_STATE == 
{
    _S0,
    _S1
}
 
__State(_state) ==
    { 
        x \in [
            xid : DOMAIN _state,
            state : T_STATE 
        ]: 
        _state[x.xid] = x.state
    }
        
__HandleNID(_nid) ==
    [

        state |-> __State(state[_nid])
    ]

RECURSIVE _InitEvent(_, _, _)

_InitEvent(
    _handle_nid(_),
    _nids,
    _event_name
) ==
    IF _nids = {} THEN
        <<>>
    ELSE 
        LET id == CHOOSE x \in _nids : TRUE
            payload == _handle_nid(id)
            action == <<[nid |-> id, state |-> payload, event |->_event_name]>>
        IN _InitEvent(
                _handle_nid,
                _nids \ {id}, 
                _event_name) \o action

            
Init == 
    /\ state \in [NID -> [MID -> {_S1, _S0}]]
    /\ event = _InitEvent(
                __HandleNID,
                NID, 
                "init" 
                ) 
                
Next1(n, m) ==
    /\ state[n][m] = _S1
    /\ event' = <<[nid |-> n, mid |-> m, state |-> _S1, event |-> "next1"]>>
    /\ UNCHANGED <<
            state
        >>

                   
Next == 
    \/ \E n \in NID, m \in MID: Next1(n, m)

    
\* The specification must start with the initial state and transition according to Next.
Spec == Init /\ [][Next]_variables



=============================================================================
