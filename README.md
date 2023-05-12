<!--- 
Hi!
Have you tried searching for your issue on the following forums?
If you have any questions, please ask them there.

Forums:
 - TLA⁺ Google Groups forum: https://groups.google.com/g/tlaplus/
 - GitHub Discussions forum: (TBA?)

Thanks!
-->

## Description
<!--- 
Provide a more detailed introduction to the issue itself, and why you consider it to be a bug. 

If you need to share a specification, either:
 - Paste it in your description between the <details> </details> tags if it's too long;
 - Send a link to a Gist, GitHub reposity, Pastebin, etc.;
-->

The model checker produced error state transitions while utilizing the symmetrical set in the [TLA+ case](https://github.com/ybbh/tla_symmetry_test).




## Expected Behavior
<!--- Tell us what should happen -->
The model checker should accurately generate state transitions for symmetrical sets.

## Actual Behavior
<!--- Tell us what happens instead -->
Some state transitions are impossible.

## Steps to Reproduce
1. git clone https://github.com/ybbh/tla_symmetry_test
2. Toolbox: File -> Open Spec -> Add New Spec -> open tla_symmetry_test.tla
3. Toolbox: models 
  -> New Model 
  -> Fill Temporal formula with **Spec** 
  -> Set constants values:

      **MID**: Sets of model values, type A, 
      ```
      {A_m}
      ```
      **NID**:  Sets of model values, check symmetry set, type A
      ``` 
      {A_n1, A_n2}
      ```
4. Uncheck Deadlock
5. Additional TLC Option -> TLC command line parameters:
   ``` 
   -dump dot dump.dot
   ```
6. Toolbox: Run TLA on the model
7. Generate state graph using the dump.dot
   ```
   dot -Tsvg dump.dot > output.svg
   ```
Then, the output file would be [output.svg](figures/output.svg).


In the state transition graph, the following transition from state **S1** to state **S2** cannot occur.

##### S1:
```
/\ state = (A_n1 :> (A_m :> "s1") @@ A_n2 :> (A_m :> "s0"))
/\ event = <<
    [state |-> [state |-> {[state |-> "s0", xid |-> A_m]}], event |-> "init", nid |-> A_n2], 
    [state |-> [state |-> {[state |-> "s1", xid |-> A_m]}], event |-> "init", nid |-> A_n1]
  >>
```

##### S2:
```
/\ state = (A_n1 :> (A_m :> "s0") @@ A_n2 :> (A_m :> "s1"))
/\ event = <<
    [state |-> "s1", event |-> "next1", nid |-> A_n2, mid |-> A_m]
  >>
```   

## Steps Taken to Fix
<!--- When this problem came up, what did you try before reporting it? -->

Do not use the symmetry set;
Remove the **event** variable in TLA+

## Possible Fix
<!--- Do you suggest some fix for us you haven't tried yet? -->


## Your Environment
<!--- Include as many relevant details about the environment in which you experienced the issue. -->
<!--- Remove information if not applicable -->
 - TLC version: 2.15, 2.16
 - TLA+ Toolbox	version: 1.7.1.202012311918, 1.8.0.202303202254   
 - Operating System: Windows 10
  <!-- (Windows 10, Ubuntu 22.04, etc.) -->
