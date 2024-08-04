$LABS = @{

    LAB_ATA = @{
       CCM =  [pscustomobject]@{
           Host = "SRRAALABATAHQ.rwn.com"
           InstallScript = 'LAB_ATA\CCM\Install-CCM.ps1'
           OrderTestFileName = @(
               @{Filename ='Regression\InstallCcmRegression.orderedtest'}
           )
           TestSettingsFileName = 'SRRAALABATAHQ.testsettings'
           Tests = @()
       }
       
       Store = [pscustomobject]@{
           Host = "SRRAALABATAST1.rwn.com"
           InstallScript = 'LAB_ATA\STORE\Install-Store.ps1'
           OrderTestFileName = @(
               @{Filename ='Regression\InstallSt1Regression.orderedtest'}
           )
           TestSettingsFileName = 'SRRAALABATAST1.testsettings'
           Tests = @()
       }

       POS1 = [pscustomobject]@{
           Host = "DTRAALABATAPOS1.rwn.com"
           InstallScript = 'LAB_ATA\POS1\Install-POS1.ps1'
           OrderTestFileName = @(
               @{Filename ='Regression\InstallPos1Regression.orderedtest'}
           )
           TestSettingsFileName = 'DTRAALABATAPOS1.testsettings'
           Tests = @(
                    )
       }
   }


}