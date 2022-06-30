using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class MedicalCard
    {
        public int? IdMedicalCard { get; set; }
        public DateTime DateOfCompletion { get; set; }
        public string Surname { get; set; }
        public string Name { get; set; }
        public string Patronymic { get; set; }
        public DateTime DateOfBirth { get; set; }
        public int GenderId { get; set; }
        public long ChiPolicy { get; set; }
        public long Snils { get; set; }

    }
}
