
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
public sealed partial class GameActions : Luban.BeanBase
{
    public GameActions(ByteBuf _buf) 
    {
        Id = _buf.ReadInt();
        Name = _buf.ReadString();
        Comment = _buf.ReadString();
    }

    public static GameActions DeserializeGameActions(ByteBuf _buf)
    {
        return new GameActions(_buf);
    }

    /// <summary>
    /// id
    /// </summary>
    public readonly int Id;
    /// <summary>
    /// 英文名 用于写代码
    /// </summary>
    public readonly string Name;
    public readonly string Comment;
   
    public const int __ID__ = 372525195;
    public override int GetTypeId() => __ID__;

    public  void ResolveRef(Tables tables)
    {
        
    }

    public override string ToString()
    {
        return "{ "
        + "id:" + Id + ","
        + "name:" + Name + ","
        + "comment:" + Comment + ","
        + "}";
    }
}

}