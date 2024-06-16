namespace Abyss
{
    public class GameBuffAttribute :System.Attribute
    {
        public int id;
        public GameBuffAttribute(int id)
        {
            this.id = id;
        }
    }
}