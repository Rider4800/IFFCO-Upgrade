pageextension 50106 pageextension50106 extends "Config. Packages"
{
    actions
    {
        addafter(ExportToTranslation)
        {
            action(DMS)
            {
                Promoted = true;
                RunObject = XMLport 50098;
            }
        }
    }
}

