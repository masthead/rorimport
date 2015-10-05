$(function	()	{

	//Form Wizard 1
	var currentStep_1 = 1;

	$("#campaign_wizard").parsley( { listeners: {
		onFieldValidate: function ( elem ) {
			// if field is not visible, do not apply Parsley validation!
			if ( !$( elem ).is( ':visible' ) ) {
				return true;
			}

			return false;
		},
        onFormSubmit: function ( isFormValid, event ) {
            if(isFormValid)	{
					
				currentStep_1++;
                console.log(currentStep_1);

				
				if(currentStep_1 == 2)	{
					$('#wizardDemo1 li:eq(1) a').tab('show');
					$('#wizardProgress').css("width","15%");
					
					$('#prevStep1').attr('disabled',false);
					$('#prevStep1').removeClass('disabled');
				}
				else if(currentStep_1 == 3)	{
					$('#wizardDemo1 li:eq(2) a').tab('show');
					$('#wizardProgress').css("width","30%");
					
					$('#nextStep1').attr('disabled',false);
					$('#nextStep1').removeClass('disabled');
				}
                else if(currentStep_1 == 3)	{
                    $('#wizardDemo1 li:eq(2) a').tab('show');
                    $('#wizardProgress').css("width","45%");

                    $('#nextStep1').attr('disabled',false);
                    $('#nextStep1').removeClass('disabled');
                }
                else if(currentStep_1 == 4)	{
                    $('#wizardDemo1 li:eq(3) a').tab('show');
                    $('#wizardProgress').css("width","60%");

                    $('#nextStep1').attr('disabled',false);
                    $('#nextStep1').removeClass('disabled');
                }
                else if(currentStep_1 == 5)	{
                    $('#wizardDemo1 li:eq(4) a').tab('show');
                    $('#wizardProgress').css("width","75%");

                    $('#nextStep1').attr('disabled',false);
                    $('#nextStep1').removeClass('disabled');
                }
                else if(currentStep_1 == 6)	{
                    $('#wizardDemo1 li:eq(5) a').tab('show');
                    $('#wizardProgress').css("width","100%");

                    $('#nextStep1').attr('disabled',true);
                    $('#nextStep1').addClass('disabled');
                }

				return false;
			}
        }
    }});
	
	$('#prevStep1').click(function()	{
		
		currentStep_1--;
		
		if(currentStep_1 == 1)	{
		
			$('#wizardDemo1 li:eq(0) a').tab('show');
			$('#wizardProgress').css("width","15%");
				
			$('#prevStep1').attr('disabled',true);
			$('#prevStep1').addClass('disabled');
			
			$('#wizardProgress').css("width","15%");
		}
		else if(currentStep_1 == 2)	{
		
			$('#wizardDemo1 li:eq(1) a').tab('show');
			$('#wizardProgress').css("width","30%");
					
			$('#nextStep1').attr('disabled',false);
			$('#nextStep1').removeClass('disabled');
			
			$('#wizardProgress').css("width","30%");
		}
        else if(currentStep_1 == 3)	{

            $('#wizardDemo1 li:eq(2) a').tab('show');
            $('#wizardProgress').css("width","45%");

            $('#nextStep1').attr('disabled',false);
            $('#nextStep1').removeClass('disabled');

            $('#wizardProgress').css("width","45%");
        }
        else if(currentStep_1 == 4)	{

            $('#wizardDemo1 li:eq(3) a').tab('show');
            $('#wizardProgress').css("width","60%");

            $('#nextStep1').attr('disabled',false);
            $('#nextStep1').removeClass('disabled');

            $('#wizardProgress').css("width","60%");
        }
        else if(currentStep_1 == 5)	{

            $('#wizardDemo1 li:eq(4) a').tab('show');
            $('#wizardProgress').css("width","75%");

            $('#nextStep1').attr('disabled',false);
            $('#nextStep1').removeClass('disabled');

            $('#wizardProgress').css("width","75%");
        }
        else if(currentStep_1 == 6)	{

            $('#wizardDemo1 li:eq(5) a').tab('show');
            $('#wizardProgress').css("width","100%");

            $('#nextStep1').attr('disabled',true);
            $('#nextStep1').addClass('disabled');

            $('#wizardProgress').css("width","100%");
        }

		return false;
	});
});