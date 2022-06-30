using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

#nullable disable

namespace PPPD_API.Models
{
    public partial class Service
    {
        public int? IdService { get; set; }
        public string Service1 { get; set; }
        public int PriceId { get; set; }
        public int CostsAndExpensesId { get; set; }

    }
    public partial class ServiceGet : Service
    {
        public Price price { get; set; }
        public CostsAndExpense costsAndExpenses { get; set; }

    }
}
