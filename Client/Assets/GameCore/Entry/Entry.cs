using System;
using UnityEngine;

namespace GameCore
{
    public partial class Entry : MonoBehaviour
    {


        private void Start()
        {
            InitBuiltinComponents();
            InitCustomComponent();
            Invoke(nameof(Test), 2f); 
        }

        private void Test()
        {
            Entry.Entity.ShowEntity<TestLogic>(1,"Assets/test.prefab", "test");
        }
    }
}