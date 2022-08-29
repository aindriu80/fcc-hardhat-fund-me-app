// import

//main function

// calling of main function

// function deployFunc(hre){
// 	hre.getNamedAccounts()
// 	hre.deployments
// 	console.log("Hello from the initial deploy function")
// }
// module.exports.default = deployFunc

module.exports  = async ({getNamedAccounts, deployments}) => {
                                                                 console.log(
                                                                     "Hello from the initial deploy function - different syntax"
                                                                 )
                                                                 const {
                                                                     deploy,
                                                                     log
                                                                 } = deployments
                                                                 const {
                                                                     deployer
                                                                 } = await getNamedAccounts()
                                                                 const chainId =
                                                                     network
                                                                         .config
                                                                         .chainId

                                                                 // when going for localhost or hardhat network we need to use a mock
                                                             }