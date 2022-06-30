using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Text;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PPPD_API.Models;

namespace PPPD_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : ControllerBase
    {
        private readonly PPPDContext _context;

        public AccountsController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/Accounts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Account>>> GetAccounts()
        {
            var accounts = await _context.Accounts.ToListAsync();
            accounts.ForEach(e => e.Password = Hash(e.Password, (DateTime.Now).ToString()));
            return accounts;
        }

        [HttpGet("{login}/{password}")]
        public async Task<ActionResult<IEnumerable<Account>>> GetAccounts(string? login, string? password)
        {
            var accounts = await _context.Accounts.ToListAsync();
            accounts.ForEach(e => e.Password = Hash(e.Password, login));
            accounts = accounts.Where(e => e.Login == login && e.Password == Hash(password, login)).ToList();

            return accounts;
        }

        // GET: api/Accounts/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Account>> GetAccount(int? id)
        {
            var account = await _context.Accounts.FindAsync(id);

            if (account == null)
            {
                return NotFound();
            }

            return account;
        }

        // PUT: api/Accounts/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAccount(int? id, [FromBody] Account account)
        {
            if (id != account.IdAccount)
            {
                return BadRequest();
            }

            _context.Entry(account).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AccountExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Accounts
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Account>> PostAccount([FromBody] Account account)
        {
            _context.Accounts.Add(account);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (AccountExists(account.IdAccount))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetAccount", new { id = account.IdAccount }, account);
        }

        // DELETE: api/Accounts/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Account>> DeleteAccount(int? id)
        {
            var account = await _context.Accounts.FindAsync(id);
            if (account == null)
            {
                return NotFound();
            }

            _context.Accounts.Remove(account);
            await _context.SaveChangesAsync();

            return account;
        }

        private bool AccountExists(int? id)
        {
            return _context.Accounts.Any(e => e.IdAccount == id);
        }

        [HttpPost("sendMail/{email}")]
        public async Task<string> SendMail(string email)
        {
            MailAddress from = new MailAddress("SeclectEmployee@yandex.ru", "Система УСОМП");

            MailAddress to = new MailAddress(email);

            MailMessage m = new MailMessage(from, to);

            string code = GenerateCode(10).ToString();

            m.Subject = "Код подтверждения";

            m.Body = $"<h2>Ваш код подтверждения. {code} </h2>";

            m.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient("smtp.yandex.com", 587);

            smtp.Credentials = new NetworkCredential("SeclectEmployee@yandex.ru", "Testpass111--!");
            smtp.EnableSsl = true;
            smtp.Send(m);

            return code;
        }

        public static string Hash(string input, string salt)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(input + salt);
            SHA256Managed sHA256ManagedString = new SHA256Managed();
            byte[] hash = sHA256ManagedString.ComputeHash(bytes);
            return Convert.ToBase64String(hash);
        }

        public static string GenerateCode(int codeLength)
        {
            string code = "";
            int r, k;

            char[] upperCase = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
            char[] lowerCase = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };
            char[] numbers = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
            Random rRandom = new Random();


            for (int i = 0; i < codeLength; i++)
            {
                r = rRandom.Next(3);

                if (r == 0)
                {
                    k = rRandom.Next(0, 25);
                    code += upperCase[k];
                }

                else if (r == 1)
                {
                    k = rRandom.Next(0, 25);
                    code += lowerCase[k];
                }

                else if (r == 2)
                {
                    k = rRandom.Next(0, 9);
                    code += numbers[k];
                }

            }

            return code;
        }
    }
}
