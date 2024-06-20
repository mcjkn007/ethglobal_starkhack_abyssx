
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
public partial class TbGameBuff
{
    private readonly System.Collections.Generic.Dictionary<int, GameBuff> _dataMap;
    private readonly System.Collections.Generic.List<GameBuff> _dataList;
    
    public TbGameBuff(ByteBuf _buf)
    {
        _dataMap = new System.Collections.Generic.Dictionary<int, GameBuff>();
        _dataList = new System.Collections.Generic.List<GameBuff>();
        
        for(int n = _buf.ReadSize() ; n > 0 ; --n)
        {
            GameBuff _v;
            _v = GameBuff.DeserializeGameBuff(_buf);
            _dataList.Add(_v);
            _dataMap.Add(_v.Id, _v);
        }
    }

    public System.Collections.Generic.Dictionary<int, GameBuff> DataMap => _dataMap;
    public System.Collections.Generic.List<GameBuff> DataList => _dataList;

    public GameBuff GetOrDefault(int key) => _dataMap.TryGetValue(key, out var v) ? v : null;
    public GameBuff Get(int key) => _dataMap[key];
    public GameBuff this[int key] => _dataMap[key];

    public void ResolveRef(Tables tables)
    {
        foreach(var _v in _dataList)
        {
            _v.ResolveRef(tables);
        }
    }

}

}

