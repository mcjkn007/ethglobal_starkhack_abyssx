
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using Luban;

namespace cfg
{
public partial class Tables
{
    public TbCardModel TbCardModel {get; }
    public TbGameActions TbGameActions {get; }
    public TbGameBuff TbGameBuff {get; }
    public TbGameMonster TbGameMonster {get; }
    public TbGameMonsterActionPattern TbGameMonsterActionPattern {get; }
    public TbGameRes TbGameRes {get; }
    public TbGameRelic TbGameRelic {get; }

    public Tables(System.Func<string, ByteBuf> loader)
    {
        TbCardModel = new TbCardModel(loader("tbcardmodel"));
        TbGameActions = new TbGameActions(loader("tbgameactions"));
        TbGameBuff = new TbGameBuff(loader("tbgamebuff"));
        TbGameMonster = new TbGameMonster(loader("tbgamemonster"));
        TbGameMonsterActionPattern = new TbGameMonsterActionPattern(loader("tbgamemonsteractionpattern"));
        TbGameRes = new TbGameRes(loader("tbgameres"));
        TbGameRelic = new TbGameRelic(loader("tbgamerelic"));
        ResolveRef();
    }
    
    private void ResolveRef()
    {
        TbCardModel.ResolveRef(this);
        TbGameActions.ResolveRef(this);
        TbGameBuff.ResolveRef(this);
        TbGameMonster.ResolveRef(this);
        TbGameMonsterActionPattern.ResolveRef(this);
        TbGameRes.ResolveRef(this);
        TbGameRelic.ResolveRef(this);
    }
}

}
