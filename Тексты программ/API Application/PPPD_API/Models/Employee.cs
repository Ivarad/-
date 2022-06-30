using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class Employee
    {
        public int? IdEmployee { get; set; }
        public int PostId { get; set; }
        public string Name { get; set; }
        public string Patronymic { get; set; }
        public string Surname { get; set; }
        public DateTime DateOfBirth { get; set; }
        public int AccountId { get; set; }
    }
}
