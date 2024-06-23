using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
namespace Dojo
{
    public static class SyncPrint
    {
        private static ConcurrentQueue<string> _queue = new ConcurrentQueue<string>();

        public static void Enqueue(string content)
        {
            _queue.Enqueue(content);
        }

        public static bool Dequeue(out string res)
        {
            if (_queue.TryDequeue(out var rtn))
            {
                res = rtn;
                return true;
            }
            res = null;
            return false;
        }
    }
}