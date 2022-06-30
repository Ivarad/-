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
    public class TypeOfMedicalCaresController : ControllerBase
    {
        private readonly PPPDContext _context;

        public TypeOfMedicalCaresController(PPPDContext context)
        {
            _context = context;
        }

        // GET: api/TypeOfMedicalCares
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TypeOfMedicalCareGet>>> GetTypeOfMedicalCares()
        {
            var typesOfMedicalCares = await _context.TypeOfMedicalCares.ToListAsync();
            var list = new List<TypeOfMedicalCareGet>();
            foreach (var type in typesOfMedicalCares)
            {
                list.Add(new TypeOfMedicalCareGet
                {
                    service = _context.Services.First(e => e.IdService == type.ServiceId),
                    price = _context.Prices.FirstOrDefault(e => e.IdPrice == _context.Services.First(e => e.IdService == type.ServiceId).PriceId),
                    costsAndExpenses = _context.CostsAndExpenses.FirstOrDefault(e => e.IdCostsAndExpenses == _context.Services.First(e => e.IdService == type.ServiceId).CostsAndExpensesId),
                    speciality = _context.MedicalSpecialties.FirstOrDefault(e => e.IdSpecialty == type.SpecialtyId),
                    IdTypeOfMedicalCare = type.IdTypeOfMedicalCare,
                    TypeOfMedicalCare1 = type.TypeOfMedicalCare1,
                    ServiceId = type.ServiceId,
                    SpecialtyId = type.SpecialtyId,
                });
            }
            return list;
        }

        // GET: api/TypeOfMedicalCares/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TypeOfMedicalCare>> GetTypeOfMedicalCare(int? id)
        {
            var typeOfMedicalCare = await _context.TypeOfMedicalCares.FindAsync(id);

            if (typeOfMedicalCare == null)
            {
                return NotFound();
            }

            return typeOfMedicalCare;
        }

        // PUT: api/TypeOfMedicalCares/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTypeOfMedicalCare(int? id, [FromBody] TypeOfMedicalCare typeOfMedicalCare)
        {
            if (id != typeOfMedicalCare.IdTypeOfMedicalCare)
            {
                return BadRequest();
            }

            _context.Entry(typeOfMedicalCare).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TypeOfMedicalCareExists(id))
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

        // POST: api/TypeOfMedicalCares
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<TypeOfMedicalCare>> PostTypeOfMedicalCare([FromBody] TypeOfMedicalCare typeOfMedicalCare)
        {
            _context.TypeOfMedicalCares.Add(typeOfMedicalCare);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTypeOfMedicalCare", new { id = typeOfMedicalCare.IdTypeOfMedicalCare }, typeOfMedicalCare);
        }

        // DELETE: api/TypeOfMedicalCares/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<TypeOfMedicalCare>> DeleteTypeOfMedicalCare(int? id)
        {
            var typeOfMedicalCare = await _context.TypeOfMedicalCares.FindAsync(id);
            if (typeOfMedicalCare == null)
            {
                return NotFound();
            }

            _context.TypeOfMedicalCares.Remove(typeOfMedicalCare);
            await _context.SaveChangesAsync();

            return typeOfMedicalCare;
        }

        private bool TypeOfMedicalCareExists(int? id)
        {
            return _context.TypeOfMedicalCares.Any(e => e.IdTypeOfMedicalCare == id);
        }
    }
}
