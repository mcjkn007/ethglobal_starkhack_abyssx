
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
public partial class TbCardModel
{
    private readonly System.Collections.Generic.Dictionary<int, CardModel> _dataMap;
    private readonly System.Collections.Generic.List<CardModel> _dataList;
    
    public TbCardModel(ByteBuf _buf)
    {
        _dataMap = new System.Collections.Generic.Dictionary<int, CardModel>();
        _dataList = new System.Collections.Generic.List<CardModel>();
        
        for(int n = _buf.ReadSize() ; n > 0 ; --n)
        {
            CardModel _v;
            _v = CardModel.DeserializeCardModel(_buf);
            _dataList.Add(_v);
            _dataMap.Add(_v.Id, _v);
        }
    }

    public System.Collections.Generic.Dictionary<int, CardModel> DataMap => _dataMap;
    public System.Collections.Generic.List<CardModel> DataList => _dataList;

    public CardModel GetOrDefault(int key) => _dataMap.TryGetValue(key, out var v) ? v : null;
    public CardModel Get(int key) => _dataMap[key];
    public CardModel this[int key] => _dataMap[key];

    public void ResolveRef(Tables tables)
    {
        foreach(var _v in _dataList)
        {
            _v.ResolveRef(tables);
        }
    }

}

}

