using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class CostsAndExpense
    {
        public int? IdCostsAndExpenses { get; set; }
        public decimal Costs { get; set; }
        public decimal Expenses { get; set; }

    }
}
