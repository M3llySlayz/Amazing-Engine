package options.wackyoptions;
//(Welcome to the Digital Circu I guess)

//Welllcommeeeee to Irshaad's Wacky Options!
//I'm Irshaad!
//I'm the Wacky Guy!
//And are you ready for some finger breaking...
//Eye Twisting...
//MIIINDD Breaking Key Swapping you've ever seen!
//Isn't that right Melly?

class WackyOptionsSubState extends BaseOptionsMenu
{
    public function new()
    {   
        

        title = "Irshaad's Wacky Options!";
        rpcTitle = "The Hell No One Asked For!";

        addOptions([
            new Option(
                'Animation Ghost Tapping',
			    "Plays Animation while on Ghost Tapping",
			    'animOnGhostTap',
			    'bool',
			    false
            ),

            new Option(
                'Splitscroll:',
			    'Only Works For 2 Strums!\nSelects your own personal hell.\nSplits your notes into something fearful.\nEach type is different, and Downscroll affects them as well.', // Enjoy The Hell =] -Irshaad
			    'splitScroll',
			    'string',
			    'None',
			    ['None', 'Normal', 'Up n\' Down', 'Double Down', 'Alt', 'Double Down Alt']
            ),

            new Option(
                'SwapScroll:',
			    'Note Swap?\nOnly Works For 2 Strums!',
			    'swapScroll',
			    'string',
			    'None',
			    ['None', 'Quarter', 'Half', 'Three Quarter', 'Full', 'Quarter Alt', 'Half Alt', 'Three Quarter Alt']
            ),

		    new Option(
                'ScrollSwap',
			    "SwapScroll but reverse.",
			    'swapReverse',
			    'bool',
			    false
            )  
        ]);

        super();
    }
}