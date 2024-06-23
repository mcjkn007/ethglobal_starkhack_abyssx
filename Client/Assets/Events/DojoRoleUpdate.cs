using GameFramework.Event;
using Unity.VisualScripting;

namespace System.Runtime.CompilerServices.Events
{
    public class DojoRoleUpdate : GameEventArgs
    {
        public static int EventId = typeof(DojoRoleUpdate).GetHashCode();
        public override int Id => EventId;

        public byte cur_stage;
        public byte selected_road;
        public ushort hp;
        public ushort maxHp;
        public ushort talent;
        public uint blessing;
        public ulong seed;
        public override void Clear()
        {
            
        }
        
        public static DojoRoleUpdate Create(byte cur_stage, 
                                                byte selected_road,
                                                ushort hp,
                                                ushort maxHp,
                                                ushort telent,
                                                uint blessing,
                                                ulong seed)
        {
            var rtn = new DojoRoleUpdate
            {
                cur_stage = cur_stage,
                selected_road = selected_road,
                hp = hp,
                maxHp = maxHp,
                talent = telent,
                blessing = blessing,
                seed = seed
            };
            return rtn;
        }
    }
}