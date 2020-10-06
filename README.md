# LinkBlox 2

![LinkBLox Logo](assets/images/link_blox_logo_125.png)

## Update Original LinkBlox Erlang Application

### Tasks and Goals

	* Translate to Elixir
	* Use Elixir documentation features
	* Create LinkBlox as a library
		* Dependency to be included when creating a block type
		* Deploy project to Hex and create Hex docs
		* Takes care of common creation, initialization, execution, deletions, and linking tasks
		* Manages list of valid block types (block type code, needs to register with
	* Store attributes in ETS tables
	* Persist block values in readable format, (JSON, XML?)
		* Allow multiple block store files to be read in
	* Implement inter-block links using Registry
	* Allow "tweak" function to be included in inter block links
		* Modify linked block output value, before writing it to block input
	* Allow creation of composite block types
		* i.e. collection of blocks to be created and manipulated as a unit 
	* Add security to user interface, login?

#### Under Construction

