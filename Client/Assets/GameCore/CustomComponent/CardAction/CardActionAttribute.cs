using System;

namespace Abyss
{
    public class CardActionAttribute : Attribute
    {
        public int Id;

        public CardActionAttribute(int id)
        {
            this.Id = id;
        }
    }
}