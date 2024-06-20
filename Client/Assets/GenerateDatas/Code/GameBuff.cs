
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
public sealed partial class GameBuff : Luban.BeanBase
{
    public GameBuff(ByteBuf _buf) 
    {
        Id = _buf.ReadInt();
        Name = _buf.ReadString();
        Alias = _buf.ReadString();
        Desc = _buf.ReadString();
        Stackable = _buf.ReadBool();
        Loss = _buf.ReadBool();
        Icon = _buf.ReadInt();
        ExtraRes1 = _buf.ReadInt();
    }

    public static GameBuff DeserializeGameBuff(ByteBuf _buf)
    {
        return new GameBuff(_buf);
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
    /// 英文名
    /// </summary>
    public readonly string Alias;
    /// <summary>
    /// 描述
    /// </summary>
    public readonly string Desc;
    /// <summary>
    /// 是否可以叠加
    /// </summary>
    public readonly bool Stackable;
    /// <summary>
    /// 是否会跟随回合移除
    /// </summary>
    public readonly bool Loss;
    /// <summary>
    /// 图标的资源路径
    /// </summary>
    public readonly int Icon;
    /// <summary>
    /// 额外的资源路径（如果有的话）
    /// </summary>
    public readonly int ExtraRes1;
   
    public const int __ID__ = -1705038971;
    public override int GetTypeId() => __ID__;

    public  void ResolveRef(Tables tables)
    {
        
        
        
        
        
        
        
        
    }

    public override string ToString()
    {
        return "{ "
        + "id:" + Id + ","
        + "name:" + Name + ","
        + "alias:" + Alias + ","
        + "desc:" + Desc + ","
        + "stackable:" + Stackable + ","
        + "loss:" + Loss + ","
        + "icon:" + Icon + ","
        + "extraRes1:" + ExtraRes1 + ","
        + "}";
    }
}

}