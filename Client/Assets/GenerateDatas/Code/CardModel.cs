
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
public sealed partial class CardModel : Luban.BeanBase
{
    public CardModel(ByteBuf _buf) 
    {
        Id = _buf.ReadInt();
        Name = _buf.ReadString();
        Desc = _buf.ReadString();
        Cost = _buf.ReadInt();
        NextLevelCardId = _buf.ReadInt();
        Res = _buf.ReadInt();
        Quality = _buf.ReadInt();
        {int n0 = System.Math.Min(_buf.ReadSize(), _buf.Size);Behaviour = new System.Collections.Generic.Dictionary<int, int>(n0 * 3 / 2);for(var i0 = 0 ; i0 < n0 ; i0++) { int _k0;  _k0 = _buf.ReadInt(); int _v0;  _v0 = _buf.ReadInt();     Behaviour.Add(_k0, _v0);}}
        FlagOperation = (gameCard.ExtraOperation)_buf.ReadInt();
        Operation = (gameCard.Operation)_buf.ReadInt();
    }

    public static CardModel DeserializeCardModel(ByteBuf _buf)
    {
        return new CardModel(_buf);
    }

    /// <summary>
    /// id
    /// </summary>
    public readonly int Id;
    /// <summary>
    /// 名称
    /// </summary>
    public readonly string Name;
    /// <summary>
    /// 描述
    /// </summary>
    public readonly string Desc;
    /// <summary>
    /// 花销
    /// </summary>
    public readonly int Cost;
    /// <summary>
    /// 升级版Id（如果已经升级过就填0或者不填）
    /// </summary>
    public readonly int NextLevelCardId;
    /// <summary>
    /// 资源路径
    /// </summary>
    public readonly int Res;
    /// <summary>
    /// 品质（从1开始）
    /// </summary>
    public readonly int Quality;
    /// <summary>
    /// id
    /// </summary>
    public readonly System.Collections.Generic.Dictionary<int, int> Behaviour;
    /// <summary>
    /// 卡牌的特殊效果；比如说如果一张卡有保留效果，就填DETAIN，如果一张卡同时有保留和虚无，就填DETAIN|ETHEREAL，如果是普通卡，就不填或者填NORMAL
    /// </summary>
    public readonly gameCard.ExtraOperation FlagOperation;
    /// <summary>
    /// 卡片打出来之后进行的步骤.所有选项可以在Datas/enums/operation.xlsx中查看
    /// </summary>
    public readonly gameCard.Operation Operation;
   
    public const int __ID__ = 1742150105;
    public override int GetTypeId() => __ID__;

    public  void ResolveRef(Tables tables)
    {
        
        
        
        
        
        
        
        
        
        
    }

    public override string ToString()
    {
        return "{ "
        + "id:" + Id + ","
        + "name:" + Name + ","
        + "desc:" + Desc + ","
        + "cost:" + Cost + ","
        + "nextLevelCardId:" + NextLevelCardId + ","
        + "res:" + Res + ","
        + "quality:" + Quality + ","
        + "behaviour:" + Luban.StringUtil.CollectionToString(Behaviour) + ","
        + "flagOperation:" + FlagOperation + ","
        + "operation:" + Operation + ","
        + "}";
    }
}

}