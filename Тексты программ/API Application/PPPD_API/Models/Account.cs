using System;
using System.Collections.Generic;

#nullable disable

namespace PPPD_API.Models
{
    public partial class Account
    {
        public int? IdAccount { get; set; }
        public string Login { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public int RoleId { get; set; }

    }
}
