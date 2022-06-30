using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PPPD_API.Models;

namespace PPPD_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReferralsController : ControllerBase
    {
        private readonly PPPDContext _context;

        public ReferralsController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/Referrals
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Referral>>> GetReferrals()
        {
            return await _context.Referrals.ToListAsync();
        }

        // GET: api/Referrals/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Referral>> GetReferral(int? id)
        {
            var referral = await _context.Referrals.FindAsync(id);

            if (referral == null)
            {
                return NotFound();
            }

            return referral;
        }

        // PUT: api/Referrals/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutReferral(int? id, [FromBody] Referral referral)
        {
            if (id != referral.IdReferral)
            {
                return BadRequest();
            }

            _context.Entry(referral).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReferralExists(id))
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

        // POST: api/Referrals
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Referral>> PostReferral([FromBody] Referral referral)
        {
            _context.Referrals.Add(referral);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetReferral", new { id = referral.IdReferral }, referral);
        }

        // DELETE: api/Referrals/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Referral>> DeleteReferral(int? id)
        {
            var referral = await _context.Referrals.FindAsync(id);
            if (referral == null)
            {
                return NotFound();
            }

            _context.Referrals.Remove(referral);
            await _context.SaveChangesAsync();

            return referral;
        }

        private bool ReferralExists(int? id)
        {
            return _context.Referrals.Any(e => e.IdReferral == id);
        }
    }
}
