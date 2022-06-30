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
    public class MedicalCardsController : ControllerBase
    {
        private readonly PPPDContext _context;

        public MedicalCardsController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/MedicalCards
        [HttpGet]
        public async Task<ActionResult<IEnumerable<MedicalCard>>> GetMedicalCards()
        {
            return await _context.MedicalCards.ToListAsync();
        }

        // GET: api/MedicalCards/5
        [HttpGet("{id}")]
        public async Task<ActionResult<MedicalCard>> GetMedicalCard(int? id)
        {
            var medicalCard = await _context.MedicalCards.FindAsync(id);

            if (medicalCard == null)
            {
                return NotFound();
            }

            return medicalCard;
        }

        // PUT: api/MedicalCards/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMedicalCard(int? id, [FromBody] MedicalCard medicalCard)
        {
            if (id != medicalCard.IdMedicalCard)
            {
                return BadRequest();
            }

            _context.Entry(medicalCard).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MedicalCardExists(id))
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

        // POST: api/MedicalCards
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<MedicalCard>> PostMedicalCard([FromBody] MedicalCard medicalCard)
        {
            _context.MedicalCards.Add(medicalCard);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMedicalCard", new { id = medicalCard.IdMedicalCard }, medicalCard);
        }

        // DELETE: api/MedicalCards/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<MedicalCard>> DeleteMedicalCard(int? id)
        {
            var medicalCard = await _context.MedicalCards.FindAsync(id);
            if (medicalCard == null)
            {
                return NotFound();
            }

            _context.MedicalCards.Remove(medicalCard);
            await _context.SaveChangesAsync();

            return medicalCard;
        }

        private bool MedicalCardExists(int? id)
        {
            return _context.MedicalCards.Any(e => e.IdMedicalCard == id);
        }
    }
}
