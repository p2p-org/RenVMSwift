import Foundation
import XCTest
import SolanaSwift
import RenVMSwift
import Task_retrying

class LockAndMintTests: XCTestCase {
    let solanaNetwork: SolanaSwift.Network = .devnet
    let renNetwork: RenVMSwift.Network = .testnet
    let solanaURL = "https://api.devnet.solana.com"
    
    var account: Account!
    var renRPCClient: RpcClient!
    var solanaRPCClient: JSONRPCAPIClient!
    var solanaBlockchainClient: BlockchainClient!
    
    override func setUp() async throws {
        account = try await Account(
            phrase: "matter outer client aspect pear cigar caution robust easily merge dwarf wide short sail unusual indicate roast giraffe clay meat crowd exile curious vibrant".components(separatedBy: " "),
            network: solanaNetwork
        )
        renRPCClient = .init(network: renNetwork)
        solanaRPCClient = .init(endpoint: .init(address: solanaURL, network: solanaNetwork))
        solanaBlockchainClient = .init(apiClient: solanaRPCClient)
    }
    
    override func tearDown() async throws {
        account = nil
        renRPCClient = nil
        solanaRPCClient = nil
        solanaBlockchainClient = nil
    }
    
    func testLockAndMint() async throws {
        let createdAt = Date(timeIntervalSinceReferenceDate: 674714392.613203)
        // Create session
        let session = try Session(createdAt: createdAt)
        
        // Initialize service
        let lockAndMint = try LockAndMint(
            rpcClient: RpcClient(network: renNetwork),
            chain: try await SolanaChain.load(
                client: renRPCClient,
                apiClient: solanaRPCClient,
                blockchainClient: solanaBlockchainClient
            ),
            mintTokenSymbol: "BTC",
            version: "1",
            destinationAddress: account.publicKey.data,
            session: session
        )
        
        // Get gateway address
        let response = try await lockAndMint.generateGatewayAddress()
        let address = Base58.encode(response.gatewayAddress.bytes)
        XCTAssertEqual(address, "2N5crcCGWhn1LUkPpV2ttDKupUncAcXJ4yM")
        
        // Get utxo
        let url = "https://blockstream.info/testnet/api/address/\(address)/utxo"
        
        
//        let state = try lockAndMint.getDepositState(
//            transactionHash: "00000000000000087312dc18acee813f5ec94b0f2a2b22f8b0cf04939ffa76bf",
//            txIndex: "1",
//            amount: "72000",
//            sendTo: response.sendTo,
//            gHash: response.gHash,
//            gPubkey: response.gPubkey
//        )
//
//        _ = try await lockAndMint.submitMintTransaction(state: state)
//
//        let tx = try await lockAndMint.mint(state: state, signer: account.secretKey)
        
    }
}


