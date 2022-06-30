using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    [NotMapped]
    public partial class ProvidedAssistance
    {
        public int? TypeOfMedicalCareId { get; set; }
        public int? ServicesRenderedId { get; set; }
    }

    public partial class ProvidedAssistanceGet : ProvidedAssistance
    {
        public ServicesRendered services { get; set; }
        public TypeOfMedicalCare typeOfMedicalCare { get; set; }
        public Service service { get; set; }
        public Price price { get; set; }
        public CostsAndExpense costsAndExpenses { get; set; }
        public MedicalSpecialty speciality { get; set; }
    }
}
