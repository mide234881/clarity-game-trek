import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can create character and level up",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("character", "create-character", 
        ["Hero"], 
        deployer.address
      ),
      Tx.contractCall("character", "add-experience",
        [types.uint(150)],
        deployer.address
      )
    ]);
    
    assertEquals(block.receipts.length, 2);
    assertEquals(block.receipts[0].result, "(ok true)");
    
    let character = chain.callReadOnlyFn(
      "character",
      "get-character",
      [],
      deployer.address
    );
    
    // Should be level 2 after gaining 150 experience
    assertEquals(character.result, '(ok {name: "Hero", level: u2, experience: u150})');
  },
});
