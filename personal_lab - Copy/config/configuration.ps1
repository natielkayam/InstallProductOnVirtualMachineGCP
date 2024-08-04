$CONFIGURATION = @{
    PathToInventoryFolder = $(Join-Path -Path $(Split-Path -Parent $PSScriptRoot) -ChildPath .\inventory -Resolve)
    PathToUtilsFolder =     $(Join-Path -Path $(Split-Path -Parent $PSScriptRoot) -ChildPath .\utils     -Resolve)
    RTISourceFolder =       $(Join-Path -Path $(Split-Path -Parent $PSScriptRoot) -ChildPath .\inventory\RTI -Resolve)

    VMWareManagementAddress = 'srraavc51.rwn.com'
    VMWareManagementUsername = 'RWN\s_raa_tfsvmoperator'
    VMWareManagementPassword = '1gT780TY?'
    DefaultSnapshotName = 'clean'

    CCMRepoName = 'ncr-swt-retail/emerald1-ccm'
    CCMServerMSIFileName = 'Server.msi'
    CCMOfficeMSIFileName = 'Central_Configuration_Manager_Store_Manager.msi'

    STSRepoName = 'ncr-swt-retail/emerald1'
    GPosWebServerMSIFileName = 'Server.msi'
    POSClientMSIFileName = 'Store_Solution_10_POS.msi'
    ForecourtMSIFileName = 'ForecourtClient.msi'    # 'Retalix_10_Forecourt.msi'

    StoreGPosWebServerMSIFileName = 'Server.msi'
    StoreOfficeMSIName = 'Store_Solution_Store_Manager.msi'

    UIAutomationFileName = 'ui-automation.tar.gz'
    
    PaymentEmulatorsFileName = 'gpdsimulator.tar.gz'
    PaymentEmulatorsFileNameAfterRepack = 'GPDSimulator.zip'
    
    R1EmulatorFileName = 'r1emulator.tar.gz'
    R1EmulatorFileNameAfterRepack = 'DataTransportationSimulator.zip'
}

